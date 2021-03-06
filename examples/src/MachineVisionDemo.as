/*---------------------------------------------------------------------------------------------

	[AS3] MachineVisionDemo
	=======================================================================================

	HiSlope toolkit copyright (c) 2010 Tomek 'Og2t' Augustyn
	http://play.blog2t.net/hislope

	You are free to use this source code in any project. 
	You are free to modify this source code in anyway you see fit.
	You are free to distribute this source code.

	You may NOT charge anything for this source code.
	This notice and the copyright information must be left intact in any distribution of this source code. 
	You are encouraged to release any improvements back to the ActionScript community.

	VERSION HISTORY:
	v0.1	Born on 7/7/2010

	USAGE:

	TODOs:

	DEV IDEAS:

	KNOWN ISSUES:

---------------------------------------------------------------------------------------------*/

package
{
	// IMPORTS ////////////////////////////////////////////////////////////////////////////////

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import hislope.filters.inputs.WebCam;
	import hislope.filters.inputs.VideoPlayer;
	import hislope.filters.FilterBase;
	import hislope.filters.pixelbender.Levels
	import hislope.filters.color.ColorGrading;
	import hislope.filters.basic.ShapeDepth;
	import hislope.filters.detectors.QuickFaceDetector;
	import hislope.filters.detectors.EyeFinder;
	import hislope.filters.visuals.MachineVision;

	import hislope.display.MetaBitmapData;
	import hislope.events.HiSlopeEvent;
	import hislope.core.FilterChain;
	import hislope.gui.Output;

	// CLASS //////////////////////////////////////////////////////////////////////////////////

	[SWF(width='800', height='600', frameRate='60', backgroundColor='0x181818')]
	public class MachineVisionDemo extends Sprite
	{
		// CONSTANTS //////////////////////////////////////////////////////////////////////////
		
		// MEMBERS ////////////////////////////////////////////////////////////////////////////
	
		private var processedBmpData:MetaBitmapData;
		private var filterChain:FilterChain;
				
		// CONSTRUCTOR ////////////////////////////////////////////////////////////////////////
		
		public function MachineVisionDemo() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			filterChain = new FilterChain("MACHINE VISION", 320, 240, true);
			addChild(filterChain);
			filterChain.x = 20;

			processedBmpData = new MetaBitmapData(FilterBase.WIDTH, FilterBase.HEIGHT, false, 0);
			var output:Output = new Output(processedBmpData, "output");
			addChild(output);
			output.x = filterChain.x + filterChain.width + 20;
			output.scale = 2.0;
	
			var inputWC:WebCam = new WebCam();
			var inputVP:VideoPlayer = new VideoPlayer();
			inputVP.addVideo("videos/black_or_white.mov", "B&W Video");
			
			filterChain.addFilter(inputVP, true);
			filterChain.addFilter(inputWC, false, false, false, false);
			
			inputVP.addEventListener(HiSlopeEvent.INPUT_RENDERED, render, false, 0, true);
			inputWC.addEventListener(HiSlopeEvent.INPUT_RENDERED, render, false, 0, true);
			
			filterChain.addFilter(new Levels(), false, false, false, false);
			filterChain.addFilter(new QuickFaceDetector({interval: 0.1}), false);
			filterChain.addFilter(new EyeFinder());
			filterChain.addFilter(new ShapeDepth());
			filterChain.addFilter(new ColorGrading({colorStart: 0x0, colorMiddle: 0x750000, colorEnd: 0xFFFFFF}));
			filterChain.addFilter(new MachineVision({radiusDeflation: 1, overlayOpacity: 0.5, points: true, lines: false, fills: false, blur: 1, linesColor: 0xFF9F00, pointsColor: 0xFFFFFF}));
		}
		
		// PUBLIC METHODS /////////////////////////////////////////////////////////////////////
		// PRIVATE METHODS ////////////////////////////////////////////////////////////////////
		// EVENT HANDLERS /////////////////////////////////////////////////////////////////////

		private function render(event:Event):void
		{
			filterChain.process(processedBmpData);
		}
		
		// GETTERS & SETTERS //////////////////////////////////////////////////////////////////
		// HELPERS ////////////////////////////////////////////////////////////////////////////
	}
}