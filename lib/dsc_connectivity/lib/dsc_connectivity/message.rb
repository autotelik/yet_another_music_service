# frozen_string_literal: true

module DscConnectivity
  # Mapscape Internal MQ messaging format. All messages should inherit from this class, to get consistent base fields,
  # and then extend message body with model specifics fields.
  #
  # The element assignment operators can be used to add basic fields, for example
  #
  #   message[:original_filename] = publish_object.attachment.filename
  #
  # TODO : Confirm with JADE and any other parties, exactly what fields are needed
  #
  class Message
    extend Forwardable

    def_delegators :raw_data, :[], :[]=

    attr_reader :json, :raw_data

    def initialize(model, sender:)
      @raw_data = ActiveSupport::HashWithIndifferentAccess.new(
        message_id:       DscConnectivity::MessageRef.generate,
        message_date:     I18n.l(DateTime.now.utc, format: :long),
        sender:           sender,
        message_status:   :pending,
        model_type:       model.class.name,
        model_id:         model.id
      )
    end

    def to_json
      raw_data.to_json
    end

    def to_object
      JSON.parse(to_json, object_class: OpenStruct)
    end

    def for_mq
      to_json
    end

    # Enable actual method calls on the base fields, like
    #   id = msg.message_id
    #   puts msg.message_status
    #
    def method_missing(sym, *args)
      return @raw_data[sym] if @raw_data && @raw_data.key?(sym)

      super
    end
  end
end
