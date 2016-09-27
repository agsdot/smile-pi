#!/usr/bin/env bash

echo "setup soe books"

cd
mkdir -p soe-bookshelf

cd ~/soe-bookshelf
rm -rf books
mkdir books
cd ~/soe-bookshelf/books
wget http://smile.edify.org/soe-bookshelf/books/01_three_boys.pdf
wget http://smile.edify.org/soe-bookshelf/books/02_story_of_a_thief.pdf
wget http://smile.edify.org/soe-bookshelf/books/03_who_is_real_hero.pdf
wget http://smile.edify.org/soe-bookshelf/books/04_indian_girl_helping_father.pdf
wget http://smile.edify.org/soe-bookshelf/books/05_indian_boy_petition.pdf
wget http://smile.edify.org/soe-bookshelf/books/06_fatuma.pdf
wget http://smile.edify.org/soe-bookshelf/books/07_greedy_fisherman.pdf
wget http://smile.edify.org/soe-bookshelf/books/08_kakam_and_rebels_1.pdf
wget http://smile.edify.org/soe-bookshelf/books/09_kakam_and_rebels_2.pdf
wget http://smile.edify.org/soe-bookshelf/books/10_mirror.pdf
wget http://smile.edify.org/soe-bookshelf/books/11_goes_to_stanford.pdf
wget http://smile.edify.org/soe-bookshelf/books/12_checkpoint.pdf
wget http://smile.edify.org/soe-bookshelf/books/13_girl_with_a_hope.pdf
wget http://smile.edify.org/soe-bookshelf/books/14_street_boy_1.pdf
wget http://smile.edify.org/soe-bookshelf/books/15_street_boy_2.pdf

cd ~/soe-bookshelf
rm -rf covers
mkdir covers
cd ~/soe-bookshelf/covers
wget http://smile.edify.org/soe-bookshelf/covers/01_three_boys.png
wget http://smile.edify.org/soe-bookshelf/covers/02_story_of_a_thief.png
wget http://smile.edify.org/soe-bookshelf/covers/03_who_is_real_hero.png
wget http://smile.edify.org/soe-bookshelf/covers/04_indian_girl_helping_father.png
wget http://smile.edify.org/soe-bookshelf/covers/05_indian_boy_petition.png
wget http://smile.edify.org/soe-bookshelf/covers/06_fatuma.png
wget http://smile.edify.org/soe-bookshelf/covers/07_greedy_fisherman.png
wget http://smile.edify.org/soe-bookshelf/covers/08_kakam_and_rebels_1.png
wget http://smile.edify.org/soe-bookshelf/covers/09_kakam_and_rebels_2.png
wget http://smile.edify.org/soe-bookshelf/covers/10_mirror.png
wget http://smile.edify.org/soe-bookshelf/covers/11_goes_to_stanford.png
wget http://smile.edify.org/soe-bookshelf/covers/12_checkpoint.png
wget http://smile.edify.org/soe-bookshelf/covers/13_girl_with_a_hope.png
wget http://smile.edify.org/soe-bookshelf/covers/14_street_boy_1.png
wget http://smile.edify.org/soe-bookshelf/covers/15_street_boy_2.png

# combining these two SO articles, to rename the images.png to images_thumb.png
# http://stackoverflow.com/questions/208181/how-to-rename-with-prefix-suffix
# http://unix.stackexchange.com/questions/56810/adding-text-to-filename-before-extension
for f in *.png; do mv "$f" "${f%.png}_thumb.png"; done

cd ~/soe-bookshelf

rm -rf bookshelf_maker
git clone https://github.com/canuk/bookshelf_maker
cd ~/soe-bookshelf/bookshelf_maker/

wget http://smile.edify.org/soe-bookshelf/seeds_of_empowerment_logo.png

sudo sed -i 's@bookshelf_title = "PDF Bookshelf"@bookshelf_title = "SOE Bookshelf"@' make_bookshelf.rb
sudo sed -i 's@logo_image = "ck12.png"@logo_image = "seeds_of_empowerment_logo.png"@' make_bookshelf.rb

mkdir -p ~/soe-bookshelf/bookshelf_maker/books
mkdir -p ~/soe-bookshelf/bookshelf_maker/covers

cp ~/soe-bookshelf/books/*.pdf  ~/soe-bookshelf/bookshelf_maker/books/
cp ~/soe-bookshelf/covers/*.png ~/soe-bookshelf/bookshelf_maker/covers/

cd ~/soe-bookshelf/bookshelf_maker/
ruby make_bookshelf.rb

cp bookshelf.html index.html

cd ~/soe-bookshelf/

mv bookshelf_maker soe-bookshelf

sudo rm -rf /usr/share/nginx/html/soe-bookshelf

sudo mv soe-bookshelf /usr/share/nginx/html/

echo "done"
