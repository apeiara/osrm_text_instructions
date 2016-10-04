module OSRMTextInstructions
  class Compiler
    attr_accessor :instructions, :version

    def initialize(instructions, version)
      @instructions = instructions
      @version = version
    end

    def compile(step)
      unless instructions[version]
        raise "Version #{version} not found for locale #{locale}"
      end

      raise 'No step maneuver provided' unless step['maneuver']

      type = step['maneuver']['type']
      modifier = step['maneuver']['modifier']

      raise 'Missing step maneuver type' unless type

      if type != 'depart' && type != 'arrive' && !modifier
        raise 'Missing step maneuver modifier'
      end

      unless instructions[version][type]
        # osrm specification assumes turn types can be added without
        # major voersion changes and unknown types are treated
        # as type `turn` by clients
        type = 'turn'
      end

      # First check if the modifier for this maneuver has a special instruction
      # If not, use the `defaultInstruction`
      instruction =
        if instructions[version][type][modifier]
          instructions[version][type][modifier]
        else
          instructions[version][type]['defaultInstruction']
        end

      # Special cases, code here should be kept to a minimum
      # If possible, change the instruction in `i18n/{locale}.yml`
      # This switch statement is for specical cases that occur at runtime
      case type
      when 'arrive'
        nth_waypoint = ''
        instruction = instruction.gsub('{nth}', nth_waypoint).gsub('  ', ' ')
      when 'depart'
        # Always use cardinal direction for departure.
        instruction = instruction.gsub('{modifier}', get_direction_from_degree(step['maneuver']['bearing_after'])[0])
      when 'notification'
        # TODO
      when 'roundabout', 'rotary'
        instruction = instruction.gsub('{rotary_name}', step['rotary_name'] || 'the rotary')
        if step['name'] && step['maneuver']['exit']
          instruction += " and take the #{step['maneuver']['exit']} exit onto {way_name}"
        elsif step['maneuver']['exit']
          instruction += " and take the #{step['maneuver']['exit']} exit"
        elsif step['name']
          instruction += ' and exit onto {way_name}'
        end
      when 'use lane'
        lane_diagram = use_lane(step)
        lane_instruction = instructions[version][type]['laneTypes'][lane_diagram]

        if lane_instruction
          instruction = instruction.gsub('{laneInstruction}', lane_instruction)
        else
          # If the lane combination is not found, default to continue
          instruction = instructions[version][type]['defaultInstruction']
        end
      end

      # Handle instructions with destinations and names
      if step['destinations'] && step['destinations'] != ''
        # only use the first destination for text instruction
        d = step['destinations'].split(',')[0]
        t = instructions[version]['templates']['destination']

        instruction = instruction
          .gsub(/\[.+\]/, t.gsub('{destination}', d))
      elsif step['name'] && step['name'] != ''
        # if no destination found, try name
        instruction = instruction
          .gsub('[', '')
          .gsub(']', '')
          .gsub('{way_name}', step['name'])
       else
         # do not use name information if not included in step
         instruction = instruction.gsub(/\[.+\]/, '')
       end

       # Cleaning for all instructions
       # If a modifier is not provided, calculate direction given bearing
       instruction = instruction
         .gsub('{modifier}', modifier || get_direction_from_degree(step['maneuver']['bearing_after'])[0])
         .strip

       instruction
    end

    def get_direction_from_degree(degree)
      OSRMTextInstructions::Utils.get_direction_from_degree(degree)
    end

    def use_lane(step)
      raise 'No lanes hash' if !step['intersections'] || !step['intersections'][0]['lanes']

      # Reduce any lane combination down to a string representing the lane config
      #
      # If the valid lanes look like:
      # "lanes": [
      #   {
      #     "valid": true
      #   },
      #   {
      #     "valid": true
      #   },
      #   {
      #     "valid": true
      #   },
      #   {
      #      "valid": false
      #   },
      #   {
      #      "valid": false
      #   },
      #   {
      #      "valid": true
      #   }
      # ]
      #
      # This would map to `oxo`
      # And the instruction would `Keep left or right...`

      diagram = []
      current_lane_type = nil

      step['intersections'][0]['lanes'].each do |lane|
        if current_lane_type.nil? || current_lane_type != lane['valid']
          if lane['valid']
            diagram.push('o')
          else
            diagram.push('x')
          end

          current_lane_type = lane['valid']
        end
      end

      diagram.join('')
    end
  end
end
