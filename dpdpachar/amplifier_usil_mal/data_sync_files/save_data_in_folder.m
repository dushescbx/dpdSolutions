function save_data_in_folder(sync_data,folder_name, file_name)

%% ������� �����
mkdir(folder_name);
%% ��������� ������
save([folder_name file_name], 'sync_data');

end