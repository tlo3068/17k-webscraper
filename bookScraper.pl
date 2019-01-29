#!/usr/bin/perl -w

# $chapter_url = "http://h5.17k.com/chapter/471287/9785375.html";
# $url = "http://h5.17k.com/list/471287.html";

# open F, "wget -q -O- $url|" or die;
# while ($line = <F>) {
#     # chomp $line;

#     print $line;

# }

@ARGV >= 1 or die "Usage: ./bookScraper.pl [BookCode]";
$prefix = "http://h5.17k.com";
$url = $prefix."/list/".$ARGV[0].".html";

print "Please enter a name for the directory\n";
$directory = <STDIN>;
chomp $directory;
mkdir $directory or die "Could not create directory\n";

print "Fetching books from $url\n";

open F, "wget -q -O- $url|" or die "Could not download url";
$found = 0;
$counter = 0;
while ($line = <F> && $counnter < 21) {
    chomp $line;
    if ($line =~ /listCont/ && $line =~ /dl/) {
        $found = 1;
    }

    if ($found == 1){
        if ($line =~ /a href/){
            # print "$line\n";
            ($chapter_link) = ($line =~ /href="(.*)"/);
            ($chapter_title) = ($line =~ /<span>(.*)<\/span>/);
            # print "$chapter_link $chapter_title\n";
            $chapter_url = $prefix.$chapter_link;
            $article_found = 0;
            open $chapter, "wget -q -O- $chapter_url|" or die "Could not get chapter";
            open $fh, '>', $directory.'/'.$chapter_title.".txt" or die "Could not create new file";
            while ($chapter_line = <$chapter>) {
                # print "$line\n";
                chomp $chapter_line;
                if ($chapter_line =~ /<article>/){
                    $article_found = 1;
                }
                if ($chapter_line =~ /<\/article/){
                    $article_found = 0;
                    $chapter_line =~ s/&#12288;&#12288;//g;
                    $chapter_line =~ s/<article>//g;
                    $chapter_line =~ s/<\/article>//g;
                    chomp $chapter_line;
                    $chapter_line =~ s/<br \/>/\n/g;
                    print $fh "$chapter_line\n";
                }
                if ($article_found == 1){
                    $chapter_line =~ s/&#12288;&#12288;//g;
                    $chapter_line =~ s/<article>//g;
                    $chapter_line =~ s/<\/article>//g;
                    chomp $chapter_line;
                    $chapter_line =~ s/<br \/>/\n/g;
                    print $fh "$chapter_line\n";
                }
            }
            close $chapter;
            close $fh;
            $chapter = $chapter + 1;
        }
    }
    if ($line =~ /<\/dl>/){
        $found = 0;
    }

}


close F;

