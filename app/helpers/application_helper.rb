# coding: utf-8
# only a way to flush some flashes..

module ApplicationHelper

  FLASHES_TO_CHECK = {
    error: 'alert-error',
    notice: 'alert-success',
    info: 'alert-error' }

  def flush_the_flash
    str = ''
    FLASHES_TO_CHECK.each do |flash_key, severity_class|
      str += flush_a_flash(flash_key, severity_class)
    end
    raw(str)
  end

  def flush_a_flash(flash_key, severity_class)
    if flash[flash_key]
      "<div class='alert #{severity_class}'>" +
        "<button type='button' class='close' data-dismiss='alert'>×</button>" +
        flash[flash_key] +
        '</div>'
    else
      ''
    end
  end
end
