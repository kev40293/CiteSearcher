package datasys.iit;

import java.util.ArrayList;

import datasys.iit.R;
import android.app.Activity;
import android.os.Bundle;
//import android.view.View.OnClickListener;
import android.util.SparseBooleanArray;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class DeleteActivity extends Activity {
	private ListView deleteList;
	public void onCreate(Bundle pickle){
		super.onCreate(pickle);
		setContentView(R.layout.delete_list);
		String [] names = ((CiteSearcher)getApplication()).getNames();
		deleteList = (ListView) findViewById(R.id.deleteList);
		deleteList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_multiple_choice, names));
		deleteList.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
	}
	public void deleteResults(View view){
		ArrayList<Article> cleanList = new ArrayList<Article>();
		ArrayList<Article> oldList =  ((CiteSearcher) getApplication()).getArticles();
		SparseBooleanArray checked = deleteList.getCheckedItemPositions();
		for (int x = 0; x < oldList.size(); x++){
			if (!checked.get(x))
				cleanList.add(oldList.get(x));
		}
		((CiteSearcher) getApplication()).setArticles(cleanList);
		String [] names = ((CiteSearcher)getApplication()).getNames();
		deleteList = (ListView) findViewById(R.id.deleteList);
		deleteList.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_multiple_choice, names));
		deleteList.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
	}
}
