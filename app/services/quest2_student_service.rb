class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.all.map do |agent|
        agent.codename
      end.join("\n")
    end

    # @return [String]
    def all_missions
      puts Mission.count
      Mission.order(title: :asc).map do |mission|
        mission.title
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.order(codename: :asc).map do |agent|
        missions_string = agent.missions.map do |mission|
          mission.title
        end.join(", ")

        "#{agent.codename}: #{missions_string}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent.includes(:missions).sort_by { |agent| -(agent.missions.count) }.map do |agent|
        missions_string = agent.missions.map do |mission|
          mission.title
        end.join(", ")

        "#{agent.codename} (#{agent.missions.count}): #{missions_string}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.all.map do |agent|
        skills_string = agent.skills.map do |skill|
          skill.name
        end.join(", ")

        "#{agent.codename}: #{skills_string}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      agent_skill = Hash.new

      AgentSkill.all.map do |item|
        unless agent_skill.key?(item.skill.name)
          agent_skill[item.skill.name] = []
        end

        agent_skill[item.skill.name] << item.agent.codename
      end

      agent_skill.to_a.sort_by { |_, agents| -(agents.count) }.map do |skill, agents|
        agents_string = agents.sort!.join(", ")

        "#{skill} (#{agents.count}): #{agents_string}"
      end.join("\n")
    end
  end
end
