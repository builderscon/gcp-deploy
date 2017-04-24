authmap: authmap.txt
	perl -anE 'system("htpasswd", "-nb", $$F[0], $$F[1])' authmap.txt | perl -ne 'print unless /^$$/' > authmap
