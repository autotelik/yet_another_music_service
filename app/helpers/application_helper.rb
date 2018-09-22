# frozen_string_literal: true

module ApplicationHelper

  # Create an icon tag with text, placed either before or after the icon
  def icon_tag(icon, text: nil, text_front: true)
    icon = "<i class=\"icon_tag #{icon}\"></i>"
    if text_front
      raw("#{text} #{icon}")
    else
      raw("#{icon} #{text}")
    end
  end

  # Text then icon
  def back_icon_tag(icon, text: nil)
    icon_tag(icon, text: text, text_front: false)
  end

  def delete_icon(model, text: nil, html_options: {})
    options = { method: :delete, remote: true, id: "delete-icon-#{model.class}-#{model.id}", data: { confirm: I18n.t(:delete_confirm, scope: :global) } }
    if text
      link_to back_icon_tag('icon-trash', text: text), model, options.merge(html_options)
    else
      link_to icon_tag('icon-trash'), model, options.merge(html_options)
    end
  end

  def remove_icon(model, text: nil, confirm: I18n.t(:remove_confirm, scope: :global), html_options: {})
    options = { method: :delete, remote: true, id: "delete-icon-#{model.class}-#{model.id}", data: { confirm: confirm } }
    if text
      link_to back_icon_tag('icon-circle-with-cross', text: text), model, options.merge(html_options)
    else
      link_to icon_tag('icon-circle-with-cross'), model, options.merge(html_options)
    end
  end

  def edit_icon(model, text: nil, html_options: {})
    options = { id: "edit-icon-#{model.class}-#{model.id}" }
    if text
      link_to back_icon_tag('icon-pencil', text: text), edit_polymorphic_path(model), options.merge(html_options)
    else
      link_to icon_tag('icon-pencil'), edit_polymorphic_path(model), options.merge(html_options)
    end
  end

  def custom_file_field(form, field, label, options: {}, additional: nil, content_for_label: nil)
    id = form.object.class.name.downcase + "-#{form.object.id}-file-input"

    content = raw "<label for='#{id}'>#{label}#{content_for_label}<i class='icon_tag icon-upload-to-cloud'></i></label>"

    content += content_tag(:span, additional, class: 'pl-1') if additional
    content += form.file_field(field, id: id, options: options)

    content_tag(:div, content, class: 'audio-upload')
  end

end
