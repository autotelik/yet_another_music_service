# frozen_string_literal: true

class TrackPresenter < Yams::Presenter

  include Yams::CoverPresenter

  def initialize(track, view)
    super(track, view)

    track.build_cover unless track.nil? || track.cover.present?
  end

  def bootstrap_actions_dropdown(except: [])
    # TODO: - Commentable  #{link_to('Comments', model) unless except.include? :comments}
    # TODO - Taggable  #{link_to('Tags', model) unless except.include? :tags}
    # TODO - Sharable   #{'<a class="dropdown-item" href="#">Share</a>' unless except.include? :delete}
    # TODO - Downloadable <a class="dropdown-item" href="#">Download</a>
    html = <<-EOS
    <div class="dropdown">
      <button class="btn btn-sm btn-outline-primary dropdown-toggle dropdown-toggle-no-arrow" type="button" id="dropdownMenuButton-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="icon-dots-three-horizontal"></i>
      </button>
      <div class="dropdown-menu dropdown-menu-sm" aria-labelledby="dropdownMenuButton">
        #{edit_icon(model, text: I18n.t(:edit, scope: :global), html_options: { class: 'dropdown-item' }) unless except.include? :edit}
        <div class="dropdown-divider"></div>
        #{view.delete_icon(model, text: 'Delete', html_options: { class: 'dropdown-item' }) unless except.include? :delete}
      </div>
    </div>
    EOS
    raw(html)
  end

end
