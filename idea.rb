require 'yaml/store'
class Idea

    attr_reader :title, :description

  def initialize(title, description)
    @title = title
    @description = description
  end

  def self.all
    raw_ideas.map do |data|
      new(data[:title], data[:description])
    end
  end
  
  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def save
    database.transaction do |db|
      db['ideas'] ||= []
      db['ideas'] << {title: title, description: description}
    end
  end

  def self.database
    @database ||= YAML::Store.new('ideabox')
  end

  # ...

  def database
    Idea.database
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea[:title], raw_idea[:description])
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end
end