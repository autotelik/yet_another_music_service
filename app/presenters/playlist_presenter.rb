# frozen_string_literal: true

class PlaylistPresenter < Yams::Presenter


  def initialize(playlist, view)
    super(playlist, view)
  end

  def bootstrap_actions_dropdown(except: [])
    except_list = *except
    
    html = <<-EOS
    <div class="dropdown">
      <button class="btn btn-sm btn-outline-primary dropdown-toggle dropdown-toggle-no-arrow" type="button" id="dropdownMenuButton-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="icon-dots-three-horizontal"></i>
      </button>
      <div class="dropdown-menu dropdown-menu-sm" aria-labelledby="dropdownMenuButton">
        #{link_to back_icon_tag('icon-pencil', text: I18n.t(:edit, scope: :global)), edit_playlist_path(playlist), { id: "edit-icon-#{model.class}-#{model.id}", class: 'dropdown-item' }  unless except_list.include? :edit}
        <div class="dropdown-divider"></div>
        #{view.delete_icon(model, text: 'Delete', html_options: { class: 'dropdown-item' }) unless except_list.include? :delete}
      </div>
    </div>
    EOS
    raw(html)
  end

  def cover_image_tag(size: :thumb, css: 'img-fluid rounded ')
    cover = playlist_tracks.present? ? playlist_tracks.first.track.cover_image : DefaultCover.for_playlist.try(:image)

    view.image_tag(polymorphic_url(cover), class: css) if cover
  end

  alias_method :playlist, :model

end
