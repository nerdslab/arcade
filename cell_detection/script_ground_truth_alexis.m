%%

%ground_truth = load_nii('100048576_293-crop_y_1151_1350_x_1651_1850_JP_anno.nii');

image = imread('100048576_293-crop.jpg');
figure, imshow(image), axis on

row_idx1 = [3000 3201]; 
col_idx1 = [700 901];

row_idx2 = [2100 2301]; 
col_idx2 = [1500 1701];

row_idx3 = [1650 1851]; 
col_idx3 = [2300 2501];

row_idx_Judy = [1151 1350]; 
col_idx_Judy = [1651 1850];

hold on, plot(col_idx1(1),row_idx1(1),'r*')
hold on, plot(col_idx1(2),row_idx1(1),'r*')
hold on, plot(col_idx1(1),row_idx1(2),'r*')
hold on, plot(col_idx1(2),row_idx1(2),'r*')
hold on, line([col_idx1(1) col_idx1(1)],[row_idx1(1) row_idx1(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx1(2) col_idx1(2)],[row_idx1(1) row_idx1(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx1(1) col_idx1(2)],[row_idx1(2) row_idx1(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx1(2) col_idx1(1)],[row_idx1(1) row_idx1(1)], 'Color','black', 'LineWidth', 2)

hold on, plot(col_idx2(1),row_idx2(1),'r*')
hold on, plot(col_idx2(2),row_idx2(1),'r*')
hold on, plot(col_idx2(1),row_idx2(2),'r*')
hold on, plot(col_idx2(2),row_idx2(2),'r*')
hold on, line([col_idx2(1) col_idx2(1)],[row_idx2(1) row_idx2(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx2(2) col_idx2(2)],[row_idx2(1) row_idx2(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx2(1) col_idx2(2)],[row_idx2(2) row_idx2(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx2(2) col_idx2(1)],[row_idx2(1) row_idx2(1)], 'Color','black', 'LineWidth', 2)

hold on, plot(col_idx3(1),row_idx3(1),'r*')
hold on, plot(col_idx3(2),row_idx3(1),'r*')
hold on, plot(col_idx3(1),row_idx3(2),'r*')
hold on, plot(col_idx3(2),row_idx3(2),'r*')
hold on, line([col_idx3(1) col_idx3(1)],[row_idx3(1) row_idx3(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx3(2) col_idx3(2)],[row_idx3(1) row_idx3(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx3(1) col_idx3(2)],[row_idx3(2) row_idx3(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx3(2) col_idx3(1)],[row_idx3(1) row_idx3(1)], 'Color','black', 'LineWidth', 2)


hold on, plot(col_idx_Judy(1),row_idx_Judy(1),'r*')
hold on, plot(col_idx_Judy(2),row_idx_Judy(1),'r*')
hold on, plot(col_idx_Judy(1),row_idx_Judy(2),'r*')
hold on, plot(col_idx_Judy(2),row_idx_Judy(2),'r*')
hold on, line([col_idx_Judy(1) col_idx_Judy(1)],[row_idx_Judy(1) row_idx_Judy(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_Judy(2) col_idx_Judy(2)],[row_idx_Judy(1) row_idx_Judy(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_Judy(1) col_idx_Judy(2)],[row_idx_Judy(2) row_idx_Judy(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_Judy(2) col_idx_Judy(1)],[row_idx_Judy(1) row_idx_Judy(1)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_Judy(1)-50 col_idx_Judy(1)-50],[row_idx_Judy(1)-50 row_idx_Judy(2)+50], 'Color','blue', 'LineWidth', 2)
hold on, line([col_idx_Judy(2)+50 col_idx_Judy(2)+50],[row_idx_Judy(1)-50 row_idx_Judy(2)+50], 'Color','blue', 'LineWidth', 2)
hold on, line([col_idx_Judy(1)-50 col_idx_Judy(2)+50],[row_idx_Judy(2)+50 row_idx_Judy(2)+50], 'Color','blue', 'LineWidth', 2)
hold on, line([col_idx_Judy(2)+50 col_idx_Judy(1)-50],[row_idx_Judy(1)-50 row_idx_Judy(1)-50], 'Color','blue', 'LineWidth', 2)

%%
saveas(gcf,'100048576_293-crop_overview.png')


anno1 = image(row_idx1(1):row_idx1(2),col_idx1(1):col_idx1(2));
figure, imshow(anno1)
nii1 = make_nii(anno1);
save_nii(nii1,'100048576_293-crop_y_3000_3201_x_700_901.nii')

anno2 = image(row_idx2(1):row_idx2(2),col_idx2(1):col_idx2(2));
figure, imshow(anno2)
nii2 = make_nii(anno2);
save_nii(nii2,'100048576_293-crop_y_2100_2301_x_1500_1701.nii')

anno3 = image(row_idx3(1):row_idx3(2),col_idx3(1):col_idx3(2));
figure, imshow(anno3)
nii3 = make_nii(anno3);
save_nii(nii3,'100048576_293-crop_y_1650_1851_x_2300_2501.nii')

anno_judy = image(row_idx_Judy(1):row_idx_Judy(2),col_idx_Judy(1):col_idx_Judy(2));
figure, imshow(anno_judy)
nii_judy = make_nii(anno_judy);
save_nii(nii_judy,'100048576_293-crop_y_1151_1350_x_1651_1850.nii')

