module ArticlesHelper
  def tag_buttons tags
    raw tags.map { |t| link_to t, tag_path(t) }.join(' ')
  end
end
