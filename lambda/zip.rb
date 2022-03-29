require 'zip'

input_directories = %w[app vendor]
output_file = '../terraform/lambda_functions.zip'
file_paths = input_directories.flat_map { |dir| Dir.glob("#{dir}/**/*").select { |f| File.file?(f) } }

# Sort all entries
::Zip.sort_entries = true

# Overwrite zip file
::Zip.on_exists_proc = false
::Zip.continue_on_exists_proc = true

::Zip::File.open(output_file, ::Zip::File::CREATE) do |zip_file|
  zip_file.restore_ownership = true
  zip_file.restore_permissions = true
  zip_file.restore_times = true

  file_paths.each do |file_path|
    zip_file.add(file_path, file_path)
  end
end
