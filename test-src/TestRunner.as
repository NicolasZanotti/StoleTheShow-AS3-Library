package
{
	import utils.SumOfArraysTest;
	import collections.BooleanDictionaryTest;
	import collections.ListTest;
	import collections.StringDictionaryTest;

	import flash.display.Sprite;

	import model.URLsTest;

	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.fluint.uiImpersonation.VisualTestEnvironmentBuilder;

	public class TestRunner extends Sprite
	{
		private var core:FlexUnitCore = new FlexUnitCore();

		public function TestRunner()
		{
			VisualTestEnvironmentBuilder.getInstance(this);
			core.addListener(new TraceListener());
			core.run(BooleanDictionaryTest, ListTest, StringDictionaryTest, URLsTest, SumOfArraysTest);
		}
	}
}