#!/bin/sh

filename="icon.png"
dirname="icon"
name_array=("Icon-20.png" "Icon-Small.png" "Icon-Small@2x.png" "Icon-Small@3x.png" "Icon-40@2x.png" "Icon-40@3x.png" "Icon.png" "Icon@2x.png" "Icon-60.png" "Icon-60@2x.png" "Icon-60@3x.png" "Icon-40.png" "Icon-Small-50.png" "Icon-Small-50@2x.png" "Icon-72.png" "Icon-72@2x.png" "Icon-76.png" "Icon-76@2x.png" "Icon-83.5@2x.png")
size_array=("20" "29" "58" "87" "80" "120" "57" "114" "60" "120" "180" "40" "50" "100" "72" "144" "76" "152" "167")
mkdir $dirname
for ((i=0;i<${#name_array[@]};++i)); do
m_dir=$dirname/${name_array[i]}
cp $filename $m_dir
sips -Z ${size_array[i]} $m_dir
done
