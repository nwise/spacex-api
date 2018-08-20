# frozen_string_literal: true

# @author Nathan Wise
class Launch
  def self.find(query_string)
    response = Typhoeus.get(
      "https://api.spacexdata.com/v2/launches?#{query_string}"
    )
    JSON.parse(response.body).first
  end

  def self.method_missing(method, *args, &_block)
    super unless respond_to_missing?(method)

    attr = method.to_s.split('find_by_').last
    send(:find, "#{attr}=#{args.first}")
  end

  def self.respond_to_missing?(method_name, include_private = false)
    (method_name.to_s.start_with?('find_by_') &&
     method_name.to_s.end_with?(*attributes)) ||
      super
  end

  def self.attributes
    %w[id flight_id flight_number rocket_id rocket_name]
  end
end
