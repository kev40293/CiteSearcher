package datasys.iit;

import java.util.ArrayList;

import android.app.Application;

public class CiteSearcher extends Application {
	private ArrayList<Article> articles;
	private String lastSearch;
	private int lowYear, hiYear, fieldOpt;
	public void onCreate(){
		articles = new ArrayList<Article>();
		lastSearch = "";
		lowYear = 1000;
		hiYear = 3000;
		fieldOpt = 0;
	}
	public String [] getNames(){
		String[] names = new String[articles.size()];
		for (int x = 0; x < names.length; x++){
        	names[x] = articles.get(x).title;
        }
		return names;
	}
	public ArrayList<Article> getArticles(){
		return articles;
	}
	public void setArticles(ArrayList<Article> newList){
		articles = newList;
		selectionSort();
	}
	public int getHIndex(){
		int index = 1;
		while (index<articles.size() && index <= articles.get(index).cites){
			index++;
		}
		return index;
	}
	public int getGIndex(){
		int index = 0;
		int total = 0;
		while (index < articles.size() && Math.pow(index, 2) <= total){
			total += articles.get(index).cites;
			index++;
		}
		return index;
	}
	public int getTotalCites(){
		int num =0;
		for (Article art : articles){
			num += art.cites;
		}
		return num;
	}
	private void selectionSort(){
		for (int x = 1; x < articles.size(); x++){
			int cur = x;
			while (cur > 0 && articles.get(cur).cites > articles.get(cur-1).cites){
				swap(cur, cur-1);
				cur--;
			}
		}
	}
	private void swap(int a, int b){
		Article temp = articles.get(a);
		articles.set(a, articles.get(b));
		articles.set(b, temp);
	}
	public boolean needMoreResults(){
		if (articles.size() == 0) return false;
		if (getGIndex() >= articles.size()) return true;
		if (getHIndex() >= articles.size()) return true;
		return false;
	}
	public void setLastSearch(String s){
		lastSearch = s;
	}
	public String theLastSearch(){
		return lastSearch;
	}
	public void setAdvancedOptions(int sY, int eY, int opt){
		lowYear = sY;
		hiYear = eY;
		fieldOpt = opt;
	}
	public int[] getAdancedOptions(){
		int [] options =  {lowYear, hiYear, fieldOpt};
		return options;
	}
}
