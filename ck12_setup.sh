#!/usr/bin/env bash

echo "setup ck-12 pdf textbooks"

sudo pacman -S ghostscript --noconfirm --needed
sudo pacman -S imagemagick --noconfirm --needed
sudo pacman -S aria2       --noconfirm --needed

cd
mkdir ck12
cd ck12
# https://archive.org/details/ck12_free_text_books_schwarzenegger_cc_by_sa
wget https://archive.org/download/ck12_free_text_books_schwarzenegger_cc_by_sa/ck12_free_text_books_schwarzenegger_cc_by_sa_archive.torrent
aria2c ck12_free_text_books_schwarzenegger_cc_by_sa_archive.torrent --seed-time=0

# http://stackoverflow.com/questions/10523415/bash-script-to-execute-command-on-all-files-in-directory
#for file in /dir/*
cd ~/ck12/ck12_free_text_books_schwarzenegger_cc_by_sa/
ls
rm -rf *.jpg
rm -rf *.png
rm -rf .DS_Store
rm -rf *.xml

for fullfile in ~/ck12/ck12_free_text_books_schwarzenegger_cc_by_sa/*
do
  filename=$(basename "$fullfile")
  extension="${filename##*.}"
  filename="${filename%.*}"
  thumbnail_name=${filename}_thumb.png

  echo " "
  echo $filename
  echo $extension
  #cmd [option] "$file" >> results.out

  echo "Get first page of pdf and convert to a smaller sized png"
  convert $(basename "$fullfile")[0] -resize 187x240 -gravity center -extent 187x240 $thumbnail_name

done

cd ~/ck12

git clone https://github.com/canuk/bookshelf_maker
cd ~/ck12/bookshelf_maker/

sudo sed -i 's@bookshelf_title = "PDF Bookshelf"@bookshelf_title = "CK-12 Bookshelf"@' make_bookshelf.rb
cp ~/vagrant-archbox/setup_files/ck12.png ~/ck12/bookshelf_maker/

mkdir ~/ck12/bookshelf_maker/books
mkdir ~/ck12/bookshelf_maker/covers

cp ~/ck12/ck12_free_text_books_schwarzenegger_cc_by_sa/*.pdf ~/ck12/bookshelf_maker/books/
cp ~/ck12/ck12_free_text_books_schwarzenegger_cc_by_sa/*.png ~/ck12/bookshelf_maker/covers/


cd ~/ck12/bookshelf_maker/
ruby make_bookshelf.rb

cp bookshelf.html index.html

cd ~/ck12

mv bookshelf_maker ck12

sudo rm -rf /usr/share/nginx/html/ck12

sude mv ck12 /usr/share/nginx/html/

echo "done"

##################################################################################################################
#scatch stuff
#gs -sDEVICE=jpeg -o jonathan.jpg -dFirstPage=1 -dLastPage=1 -dJPEGQ=30 -r200x200 242-1228-1-PB.pdf
#convert jonathan.jpg -resize 129x166 jonathan_thumb.jpg
