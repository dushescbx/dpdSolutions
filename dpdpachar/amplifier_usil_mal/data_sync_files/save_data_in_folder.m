function save_data_in_folder(sync_data,folder_name, file_name)

%% создаем папку
mkdir(folder_name);
%% сохраняем данные
save([folder_name file_name], 'sync_data');

end