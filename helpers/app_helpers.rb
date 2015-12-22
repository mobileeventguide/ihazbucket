module AppHelpers
  include Padrino::Helpers

  def alert_dismiss
    content_tag :button, type: 'button', class: 'close',
      data: { dismiss:'alert' }, aria: { label:'Close' } do
      content_tag :span, '&times;'.html_safe, aria: { hidden:'true' }
    end
  end
end
