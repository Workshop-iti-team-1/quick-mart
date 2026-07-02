require 'xcodeproj'

project_path = 'QuickMart.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.find { |t| t.name == 'QuickMart' }

def get_group_from_path(project, path_string)
  components = path_string.split('/')
  group = project.main_group
  components.each do |comp|
    next_group = group.children.find { |c| c.name == comp || c.path == comp }
    if next_group.nil?
      next_group = group.new_group(comp, comp)
    end
    group = next_group
  end
  group
end

# 1. Remove missing files from target
def remove_missing_files(group, target)
  group.children.dup.each do |child|
    if child.class == Xcodeproj::Project::Object::PBXFileReference
      unless File.exist?(child.real_path)
        puts "Removing #{child.path}"
        build_files = target.source_build_phase.files.select { |f| f.file_ref == child }
        build_files.each { |f| f.remove_from_project }
        child.remove_from_project
      end
    elsif child.class == Xcodeproj::Project::Object::PBXGroup
      remove_missing_files(child, target)
    end
  end
end

remove_missing_files(project.main_group, target)

# 2. Add specific directories / files

def add_files_to_group(project, target, group, dir_path)
  Dir.foreach(dir_path) do |entry|
    next if entry == '.' or entry == '..' or entry == '.DS_Store'
    
    full_path = File.join(dir_path, entry)
    if File.directory?(full_path)
      sub_group = group.children.find { |c| (c.name == entry || c.path == entry) && c.class == Xcodeproj::Project::Object::PBXGroup }
      sub_group ||= group.new_group(entry, entry)
      add_files_to_group(project, target, sub_group, full_path)
    else
      file_ref = group.files.find { |f| f.path == entry || f.name == entry }
      unless file_ref
        file_ref = group.new_file(entry)
        puts "Added file reference: #{entry}"
      end
      
      if entry.end_with?('.swift') && !target.source_build_phase.files_references.include?(file_ref)
        target.add_file_references([file_ref])
        puts "Added to target: #{entry}"
      end
    end
  end
end

network_group = get_group_from_path(project, 'QuickMart/Core/Network')
add_files_to_group(project, target, network_group, 'QuickMart/Core/Network')

home_ds_group = get_group_from_path(project, 'QuickMart/Modules/Home/Data/DataSource')
add_files_to_group(project, target, home_ds_group, 'QuickMart/Modules/Home/Data/DataSource')

project.save
puts "Project updated successfully"
