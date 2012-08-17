package datasys.iit;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import datasys.iit.R;
import java.util.Scanner;
import java.net.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.io.*;

import net.htmlparser.jericho.Element;
import net.htmlparser.jericho.Source;
import net.htmlparser.jericho.CharacterReference;
import android.widget.EditText;

public class SearchActivity extends Activity implements OnItemClickListener{
	private ArrayList<Article> resultList;
	private ListView results;
	private String toSearch;
	public final String TAG = "HelloWorldApp";
	private ProgressDialog dialog;
	private final boolean testing = false;
	//as_subj=bio&as_subj=med&as_subj=bus&as_subj=phy&as_subj=chm&as_subj=soc&as_subj=eng
	private final String [] fields = {"eng", "bio", "med", "bus", "phy", "chm", "soc"};
	
    /** Called when the activity is first created. */
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);
        results = (ListView) findViewById(R.id.listView1);
        results.setOnItemClickListener(this);
        String [] names = ((CiteSearcher)getApplication()).getNames();
        results.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, names));
        ((EditText) findViewById(R.id.SearchBox)).setText(((CiteSearcher) getApplication()).theLastSearch());
        toSearch = ((CiteSearcher) getApplication()).theLastSearch();
    }
    private class RequestThread implements Runnable{
    	public RequestThread(){
    		
    	}
    	public void run(){
    		try{
    			if(testing) return;
    			URL url = new URL("http://datasys.cs.iit.edu/projects/CiteSearcher/dataManager.php");
    			HttpURLConnection request = (HttpURLConnection) url.openConnection();
    			Date now = new Date();
    			String format = "		<time>"+ now.toString() +"</time>\n" +
    			"		<version>"+ R.string.Version + "</version>\n" +
    			"		<search>"+toSearch.replace('+', ' ') +"</search>\n";
    			String data = URLEncoder.encode("data", "UTF-8") + "=" +
    					URLEncoder.encode(format, "UTF-8");
				request.setRequestMethod("POST");
				request.setRequestProperty("User-Agent", "CiteSearcher");
				request.setDoOutput(true);
				OutputStreamWriter wr = new OutputStreamWriter(request.getOutputStream());
				wr.write(data);
				wr.flush();
				
				BufferedReader read = new BufferedReader(new InputStreamReader(request.getInputStream()));
				wr.close();
				read.close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
    }

    public void search(View view){
    	InputMethodManager inputManager = (InputMethodManager) this.getSystemService(Context.INPUT_METHOD_SERVICE); 
    	inputManager.hideSoftInputFromWindow(this.getCurrentFocus().getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);
    	String query = ((TextView) findViewById(R.id.SearchBox)).getText().toString();
    	toSearch = "";
    	Scanner scan = new Scanner(query);
    	scan.useDelimiter(" ");
    	while (scan.hasNext()){
    		String token = scan.next();
    		toSearch += (token.equals("") ? "author:" + token : token + "+");
    	}
    	if (toSearch.length() == 0) return;
    	toSearch = toSearch.substring(0, toSearch.length()-1);
    	dialog = new ProgressDialog(this);
    	dialog.setMessage("Loading Results...");
    	dialog.setCancelable(false);
    	dialog.show();
    	//this.mLockScreenRotation();
    	new Thread(new Runnable(){
    		public void run(){
    			searchString(toSearch);
    	        handler.sendEmptyMessage(0);
    	    }
    	}).start();
    	new Thread(new RequestThread()).start();
    }
    	
    public void searchString(String query){
    	resultList = new ArrayList<Article>();
    	int start = 0;
    	do{
    	try{
    		int[] options = ((CiteSearcher) getApplication()).getAdancedOptions();
    		String url = "http://scholar.google.com/scholar?num=100&start="+start+"&q=" + query;
    		for (int x =0; x < fields.length; x++){
    			url += ((options[2] & (1<<x)) > 0 ? "&as_subj="+fields[x] : "");
    		}
    		url += ("&as_ylo=" + options[0] + "&as_yhi=" + options[1]);
			URL search = new URL(url);
			Log.i(TAG,url);
			HttpURLConnection request = (HttpURLConnection) search.openConnection();
			request.setRequestMethod("GET");
			request.setRequestProperty("user-agent", "Mozilla/5.0");
			Source source = new Source(request);
			List<Element> allElements = source.getAllElementsByClass("gs_r");
			for (Element el : allElements){
				List<Element> citeCounts = el.getAllElementsByClass("gs_fl");
				List<Element> authors = el.getAllElementsByClass("gs_a");
				List<Element> pdfs = el.getAllElementsByClass("gs_ggs gs_fl");
				String name = "No Author";
				String title = "No Title";
				String pdf = "No PDF";
				String href = "No URL";
				int numberCites = 0;
				try {title = CharacterReference.decodeCollapseWhiteSpace(el.getAllElementsByClass("gs_rt").get(0).getFirstElement("a").getContent()); } catch (Exception e) { continue; }
				try {name = CharacterReference.decodeCollapseWhiteSpace(authors.get(0).getContent()).replaceAll("<b>", "").replaceAll("</b>", ""); } catch (Exception e) {}
				try {href = el.getFirstStartTag("a").getAttributeValue("href"); } catch (Exception e) {}
				try {pdf = pdfs == null ? "No PDF" : pdfs.get(0).getFirstStartTag("a").getAttributeValue("href"); } catch (Exception e) {}
				try {
					numberCites = Integer.parseInt(CharacterReference.decodeCollapseWhiteSpace(citeCounts.get(1).getFirstElement("a").getContent()).substring(9)); 
				} catch (Exception e) {
					try{
						numberCites = Integer.parseInt(CharacterReference.decodeCollapseWhiteSpace(citeCounts.get(0).getFirstElement("a").getContent()).substring(9));
					}catch (Exception exc){
						continue;
					}
				}
				Article art = new Article(title, name, href, pdf, numberCites);
				resultList.add(art);
		    	((CiteSearcher) getApplication()).setArticles(resultList);
			}
			start += 100;
		}catch (Exception e){
			e.printStackTrace();
		}
    	}while (((CiteSearcher) getApplication()).needMoreResults());
    	((CiteSearcher) getApplication()).setLastSearch(query.replace('+', ' '));
	}

	public void onItemClick(AdapterView<?> adapter, View view, int pos, long id) {
		Article temp = ((CiteSearcher)getApplication()).getArticles().get(pos);
		Intent intent = new Intent(this, ArticleViewer.class);
		intent.putExtra("title", temp.title);
		intent.putExtra("author", temp.author);
		intent.putExtra("url", temp.siteURL);
		intent.putExtra("pdf", temp.PDFURL == null ? "No PDF" : temp.PDFURL);
		intent.putExtra("cites", temp.cites+"");
		startActivity(intent);
	}
	private Handler handler = new Handler(){
		public void handleMessage(Message msg) {
	        setAdapter(((CiteSearcher)getApplication()).getNames());
			dialog.dismiss();
		}
	};
	public void setAdapter(String [] names){
		results.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, names));
    	//unlockScreenOrientation(this);
	}
	public void onConfigurationChangeed(Configuration newConfig){
		super.onConfigurationChanged(newConfig);
		dialog.show();
	}
//	private void mLockScreenRotation()
//	{
//	  // Stop the screen orientation changing during an event
//	    switch (this.getResources().getConfiguration().orientation)
//	    {
//	  case Configuration.ORIENTATION_PORTRAIT:
//	    this.setRequestedOrientation(
//	ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
//	    break;
//	  case Configuration.ORIENTATION_LANDSCAPE:
//	    this.setRequestedOrientation(
//	ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
//	    break;
//	    }
//	}
	public static void unlockScreenOrientation(Activity a) {
	    a.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_USER);
	}
	public boolean onCreateOptionsMenu(Menu menu){
		if (menu == null) return false;
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.options, menu);
		return true;
	}
	public boolean onOptionsItemSelected(MenuItem item){
		Intent intent;
		switch (item.getItemId()){
		case R.id.authorinfo:
			if (toSearch == null) break;
			intent = new Intent(this, AuthorView.class);
			intent.putExtra("name", toSearch.replace('+', ' '));
			startActivity(intent);
			break;
		case R.id.info:
			intent = new Intent(this, InfoView.class);
			startActivity(intent);
			break;
		case R.id.delete:
			intent = new Intent(this, DeleteActivity.class);
			startActivity(intent);
			//deleteMode = !deleteMode;
			//setAdapter(((CiteSearcher) getApplication()).getNames());
			break;
		case R.id.advOpt:
			intent = new Intent(this, SearchOptions.class);
			startActivity(intent);
			break;
//		case R.id.cancel:
//			deleteMode = !deleteMode;
//			break;
		}
		return true;
	}
	public void deleteResults(){
		for (int x = 0; x < results.getCount(); x++){
			if (results.getChildAt(x).isSelected()) {/*do something */}
		}
	}
	public void onRestart(){
		super.onRestart();
		this.setAdapter(((CiteSearcher)getApplication()).getNames());
	}
}