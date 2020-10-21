# frozen_string_literal: true

module ActiveTopic
  module Exceptions
    class Base < StandardError; end

    class CantBeIniatilized < Base; end

    class TopicAlreadyExists < Base; end
    
    class TopicNotFound < Base; end
  end
end
