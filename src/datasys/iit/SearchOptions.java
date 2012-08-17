package datasys.iit;

import android.app.Activity;
import android.os.Bundle;
import android.util.SparseBooleanArray;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.ListView;

public class SearchOptions extends Activity {
	private int options, sYear, eYear;
	private String[] values = {
			"Engineering, Computer Science, and Mathematics",
			"Biology, Life Sciences, and Environmental Science",
			"Medicine, Pharmacology, and Veterinary Science",
			"Business, Administration, Finance, and Economics",
			"Physics, Astronomy, and Planetary Science",
			"Chemistry and Materials Science",
			"Social Sciences, Arts, and Humanities"};
	private ListView list;
	private EditText begYear, endYear;
	//private Button confirm;
	public void onCreate(Bundle pickle){
		super.onCreate(pickle);
		int [] o = ((CiteSearcher) getApplication()).getAdancedOptions();
		options = o[2];
		sYear = o[0];
		eYear = o[1];
		setContentView(R.layout.search_options);
		list = (ListView) findViewById(R.id.fields);
		begYear = (EditText) findViewById(R.id.startYear);
		endYear = (EditText) findViewById(R.id.endYear);
		//confirm = (Button) findViewById(R.id.setButton);
		begYear.setText(""+sYear);
		endYear.setText(""+eYear);
		list.setAdapter(new ArrayAdapter<String>(this, android.R.layout.simple_list_item_multiple_choice, values));
		list.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
		for (int i =0; i<values.length; i++){
			if ((options & (1 << i)) > 0){
				list.setItemChecked(i, true);
			}
		}
	}
	public void setOptions(View view){
		SparseBooleanArray checked = list.getCheckedItemPositions();
		for (int x = 0; x < values.length; x++){
			if (checked.get(x))
				options = options |(1<<x);
			else
				options = options & ~(1<<x);
		}
		try{
			sYear = Integer.parseInt(begYear.getText().toString());
		}catch(Exception e){ sYear = 1000;}
		try{
			eYear = Integer.parseInt(endYear.getText().toString());
		}catch(Exception e){ eYear = 3000;}
		((CiteSearcher) getApplication()).setAdvancedOptions(sYear,eYear,options);
		finish();
	}
}
