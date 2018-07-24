ActionController::Renderers.add :docx do |filename, options|
  formats[0] = :docx unless formats.include?(:docx) || Rails.version < '3.2'

  # This is ugly and should be solved with regular file utils
  if options[:template] == action_name
    if filename =~ %r{^([^\/]+)/(.+)$}
      options[:prefixes] ||= []
      options[:prefixes].unshift $1
      options[:template] = $2
    else
      options[:template] = filename
    end
  end

  # disposition / filename
  disposition = options.delete(:disposition) || 'attachment'
  if file_name = options.delete(:filename)
    file_name += '.docx' unless file_name =~ /\.docx$/
  else
    file_name = "#{filename.gsub(/^.*\//, '')}.docx"
  end

  # other properties
  save_to = options.delete(:save_to)
  word_template = options.delete(:word_template) || nil
  extras = options.delete(:extras) || false

  # content will come from property content unless not specified
  # then it will look for a template.
  content = options.delete(:content) || render_to_string(options)
  document = Htmltoword::Document.create(content, word_template, extras)
  File.open(save_to, "wb") { |out| out << document } if save_to
  send_data document, filename: file_name, type: Mime::DOCX, disposition: disposition
end
