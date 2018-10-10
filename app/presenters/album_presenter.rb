# frozen_string_literal: true

class AlbumPresenter < Yams::Presenter

  include Yams::CoverPresenter

  def initialize(album, view)
    super(album, view)

    album.build_cover if album && album.cover.blank?
  end

  def bootstrap_actions_dropdown(except: [])
    except_list = *except

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
        #{link_to back_icon_tag('icon-pencil', text: I18n.t(:edit, scope: :global)), edit_album_path(album), { id: "edit-icon-#{model.class}-#{model.id}", class: 'dropdown-item' }  unless except_list.include? :edit}
        <div class="dropdown-divider"></div>
        #{view.delete_icon(model, text: 'Delete', html_options: { class: 'dropdown-item' }) unless except_list.include? :delete}
      </div>
    </div>
    EOS
    raw(html)
  end

  alias_method :album, :model

end
