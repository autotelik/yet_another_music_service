# frozen_string_literal: true

module BootstrapHelper

  def map_flash_bootstrap( name )
    if name.to_s == 'notice'
      'success'
    elsif name == 'response'
      'info'
    else
      'danger'
    end
  end
  
  def bootstrap_actions_dropdown(model, except: [])
    html = <<-EOS
    <div class="dropdown">
      <button class="btn btn-sm btn-outline-primary dropdown-toggle dropdown-toggle-no-arrow" type="button" id="dropdownMenuButton-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="icon-dots-three-horizontal"></i>
      </button>
      <div class="dropdown-menu dropdown-menu-sm" aria-labelledby="dropdownMenuButton">
        <a class="dropdown-item" href="#">Download</a>
        #{'<a class="dropdown-item" href="#">Share</a>' unless except.include? :delete}
        # TODO - Commentable  #{link_to('Comment', model) unless except.include? :delete}
        <div class="dropdown-divider"></div>
        #{delete_icon(model, text: 'Delete', html_options: { class: 'dropdown-item' }) unless except.include? :delete}
      </div>
    </div>
    EOS
    raw(html)
  end

  def bootstrap_card_header(heading)
    html = <<-EOS
    <div class="card-header">
      <div>
       <h5 class=".text-light">#{heading}</h5>
      </div>
    </div>
    EOS
    raw(html)
  end

  def bootstrap_submit(form:, text:, css: 'btn btn-block btn-lg float-right')
    content_tag(:div, class: 'form-row form-group float-right') do
      content_tag(:div, class: 'col') do
        form.submit(text, class: css)
      end
    end
  end

end
