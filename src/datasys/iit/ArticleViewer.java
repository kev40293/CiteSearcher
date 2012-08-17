package datasys.iit;

import datasys.iit.R;
import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class ArticleViewer extends Activity {
	public void onCreate(Bundle pickle){
		super.onCreate(pickle);
		setContentView(R.layout.article);
		Bundle data = getIntent().getExtras();
		//theArticle = (Article) pickle.get("article");
		((TextView) findViewById(R.id.titlebox)).setText(data.getString("title"));
		((TextView) findViewById(R.id.authorbox)).setText(data.getString("author"));
		((TextView) findViewById(R.id.urlbox)).setText(data.getString("url"));
		((TextView) findViewById(R.id.pdfbox)).setText(data.getString("pdf"));
		((TextView) findViewById(R.id.citebox)).setText(data.getString("cites"));
	}
}
