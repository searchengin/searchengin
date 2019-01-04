module FormHelper

  def setup_who_tag who_tag
    who_tag.build_who_datum
    who_tag
  end

  def setup_where_tag where_tag
    where_tag.build_where_datum
    where_tag
  end

  def setup_what_tag what_tag
    what_tag.build_what_datum
    what_tag
  end

  def setup_whene_tag when_tag
    when_tag.build_when_datum
    when_tag
  end

  def setup_why_tag why_tag
    why_tag.build_why_datum
    why_tag
  end

  def setup_video_tag video_tag
    video_tag.build_video_datum
    video_tag
  end

  def setup_photo_tag photo_tag
    photo_tag.build_photo_datum
    photo_tag
  end

end
