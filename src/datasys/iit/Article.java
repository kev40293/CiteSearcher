package datasys.iit;

public class Article{
	public String author;
	public String title;
	public String siteURL;
	public String PDFURL;
	public int cites;
	public Article(String t, String a, String site, String PDF, int numberCites){
		title = t;
		author = a;
		siteURL = site;
		PDFURL = PDF;
		cites = numberCites;
	}
}