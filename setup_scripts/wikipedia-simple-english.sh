

# Wikipedia (simple English)
wget http://download.kiwix.org/portable/wikipedia_en_simple_all.zip.torrent
aria2c wikipedia_en_simple_all.zip.torrent --seed-time=0

for file in kiwix*wikipedia_en_simple_all_*.zip; do

done



# Wikipedia (Telugu)
wget http://download.kiwix.org/portable/wikipedia_te_all.zip.torrent
aria2c wikipedia_te_all.zip.torrent --seed-time=0

# Wikipedia (Hindi)
wget http://download.kiwix.org/portable/wikipedia_hi_all.zip.torrent
aria2c wikipedia_hi_all.zip.torrent --seed-time=0
