package
{
	import collections.BooleanDictionaryTest;
	import collections.ListTest;
	import collections.StringDictionaryTest;
	import collections.XMLStringDictionaryTest;

	import model.URLsTest;

	import utils.SumOfArraysTest;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

	import flash.display.Sprite;

	public class TestRunner extends Sprite
	{
		private var core:FlexUnitCore = new FlexUnitCore();

		public function TestRunner()
		{
			VisualTestEnvironmentBuilder.getInstance(this);
			core.addListener(new TraceListener());
			core.run(BooleanDictionaryTest, ListTest, StringDictionaryTest, XMLStringDictionaryTest, URLsTest, SumOfArraysTest);
		}
	}
}