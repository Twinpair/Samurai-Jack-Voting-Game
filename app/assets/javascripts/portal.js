jQuery(document).ready(function($){

	function ProjectMask( element ) {
		this.element = element;
		this.projectTrigger = this.element.find('.project-trigger');
		this.projectClose = this.element.find('.project-close'); 
		this.projectTitle = this.element.find('h1');
		this.projectMask = this.element.find('.mask');
		this.maskScaleValue = 1;
		this.bgImage = this.element.find('.featured-image');
		this.projectContent = this.element.find('.cd-project-info');
		this.projectContentUrl = this.projectContent.data('url');
		this.animating = false;
		this.scrollDown = this.element.find('.cd-scroll');
		this.scrolling = false;
		this.initProject();
	}

	ProjectMask.prototype.initProject = function() {
		var self = this;

		//open the project
		if( !self.animating ) {
			self.animating = true;
			//upload project content
			self.uploadContent();
			//scroll the page so that the project section is in the viewport
			if( $(window).scrollTop() == self.element.offset().top ) {
				self.revealProject();
			} else {
				self.revealProject();
			} 
		};
	};

	ProjectMask.prototype.revealProject = function() {
		var self = this;
		//update mask scale value
		self.updateMaskScale();
		//scale up mask and project bg image + hide project title
		self.projectTitle.attr('style', 'opacity: 0;');
		self.projectMask.css('transform', 'translateX(-50%) translateY(-50%) scale('+self.maskScaleValue+')').one(transitionEnd, function(){
			self.projectMask.off(transitionEnd);
			self.animating = false;
			self.element.addClass('center-title');
		});

		//hide the other sections
		self.element.addClass('project-selected content-visible').parent('.cd-image-mask-effect').addClass('project-view');
	}
	
	ProjectMask.prototype.updateMask = function() {
		var self = this;
		if( this.element.hasClass('project-selected') ) { //the project is already open - rescale mask
			//update mask scale value
			this.updateMaskScale();
			this.element.addClass('no-transition');

			//triggering reflow so that transition is not applied
			void self.projectMask.get(0).offsetWidth;
			self.projectMask.css('transform', 'translateX(-50%) translateY(-50%) scale('+self.maskScaleValue+')');
			void self.projectMask.get(0).offsetWidth;
			self.element.removeClass('no-transition');
		}
	}

	ProjectMask.prototype.updateMaskScale = function() {
		// scaleMask = viewport diagonal*5 divided by mask width
		this.maskScaleValue = Math.sqrt(Math.pow($(window).height(), 2) + Math.pow($(window).width(), 2))*3*this.maskScaleValue/this.projectMask.width();
	}

	ProjectMask.prototype.uploadContent = function(){
		var self = this;
		if( self.projectContent.find('.content-wrapper').length == 0 ) self.projectContent.load(self.projectContentUrl+' .cd-project-info > *');
		
		if( self.projectContentUrl!=window.location ){
	        //add the new page to the window.history
	        window.history.pushState({path: self.projectContentUrl},'',self.projectContentUrl);
	    }
	}

	var revealingProjects = $('.cd-project-mask');
	var objProjectMasks = [],
		windowResize = false;

	var transitionEnd = 'webkitTransitionEnd otransitionend oTransitionEnd msTransitionEnd transitionend';

	if( revealingProjects.length > 0 ) {
		revealingProjects.each(function(){
			//create ProjectMask objects
			objProjectMasks.push(new ProjectMask($(this)));
		});
	}

	$(window).on('resize', function(){
		if( !windowResize ) {
			windowResize = true;
			(!window.requestAnimationFrame) ? setTimeout(checkResize) : window.requestAnimationFrame(checkResize);
		}
	});

	function checkResize(){
		objProjectMasks.forEach(function(element){
			element.updateMask();
		});
		windowResize = false;
	}
});