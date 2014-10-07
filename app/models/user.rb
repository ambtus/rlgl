# coding: utf-8
class User < ActiveRecord::Base
  DATEREGEXP = /\A(\d+(?:\.\d+)?)(?:[, ]+(\d+(?:\.\d+)?)){0,8}\z/m

  validates_presence_of :name
  validates :weights, format: { with: DATEREGEXP,
    message: "must be one to nine decimal numbers separated by commas and/or spaces" }

  def weights_array; weights.split(/[, ]+/).map(&:to_f); end

  def current_sma; weights_array[-6,6].sum/6; end

  def previous_sma; weights_array[0,6].sum/6; end

  def delta; current_sma - previous_sma; end

  def signal
    if delta > 0.25
      return "red"
    elsif delta < -0.25
      return "green"
    else
      return "yellow"
    end
  end

  def days; (Date.today - updated_at.to_date).to_int; end

  def days_ago
    if days == 1
      "yesterday."
    elsif days > 1
      "#{days} days ago."
    end
  end

  def maximum; days > 9 ? 9 : days; end

  def message
    if days == 1
      "Please enter today’s weight."
    elsif days > 1
      "Please enter today’s weight, and up to #{maximum-1} previous weights (today’s weight last)."
    end
  end

  def new_weights(string)
    return false unless string.match(DATEREGEXP)
    new_weights_array = string.split(/[, ]+/).map(&:to_f)
    self.weights = (weights_array + new_weights_array)[-9, 9].join(" ")
    save
  end

  def ready?; weights_array.size == 9; end
  def today?; days == 0; end

end
