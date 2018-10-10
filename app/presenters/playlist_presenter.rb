# frozen_string_literal: true

class PlaylistPresenter < Yams::Presenter


  def initialize(playlist, view)
    super(playlist, view)
  end

  def bootstrap_actions_dropdown(except: [])
    except_list = *except

    html = <<-EOS
    <div class="dropdown">
    </div>
    EOS
    raw(html)
  end

  def cover_image_tag
    tracks.present? ? tracks.first.cover_image : DefaultCover.for_playlist
  end

  alias_method :playlist, :model

end
