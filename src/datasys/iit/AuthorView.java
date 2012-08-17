package datasys.iit;

import datasys.iit.R;
import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class AuthorView extends Activity {
	public void onCreate(Bundle pickle){
		super.onCreate(pickle);
		setContentView(R.layout.author);
		Bundle data = getIntent().getExtras();
		CiteSearcher app = (CiteSearcher) getApplication();
		((TextView) findViewById(R.id.namebox)).setText(data.getString("name"));
		((TextView) findViewById(R.id.totalcitesbox)).setText(app.getTotalCites()+"");
		((TextView) findViewById(R.id.hindexbox)).setText(app.getHIndex()+"");
		((TextView) findViewById(R.id.gindexbox)).setText(app.getGIndex()+"");
	}
}
