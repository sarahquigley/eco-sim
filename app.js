angular.module('EcoSim', [])

	.controller('Controller', ["$scope", "$timeout", function ($scope, $timeout) 
		{	
			$scope.CreatureType = 'green';
			var Creature = function (x,y) {
				this.Type = $scope.CreatureType; 
				this.Energy = 9;
				this.x = x; this.y = y;
			};
			Creature.prototype.Move = function() { if(this.Energy > 0) {this.x +=  Math.random() * (2) - 1; this.y +=  Math.random() * (2) - 1; this.Energy -= 0.1;} 
				else this.Energy -= 0.01; if(this.Energy < -10) this.Die(); };
			Creature.prototype.Eat = function() {
				var that = this; 
				angular.forEach($scope.Creatures, function (Prey, i) 
				{ //console.log('Eating...', Prey.x, this.x);
					if( Math.abs(Prey.x - that.x) < 2 && Math.abs(Prey.y - that.y) < 2 && !angular.equals(Prey,that) ) // make into a vector distance later	
					{ Prey.Die(i); that.Energy += 9; }
				});
			};
			Creature.prototype.Die = function(i) { $scope.Creatures.splice(i,1); };
			Creature.prototype.Reproduce = function() { if(this.Energy > 10) 
				{
				AddCreature(this.x+Math.random() * 4 - 2, this.y+Math.random() * 4 - 2 ); 
				this.Energy -=10; 
				}
			}; 


			var AddCreature = function (x,y) {
				var myCreature = new Creature(x,y);  
				$scope.Creatures.push(myCreature);
			}
			$scope.Creatures = [];
			
			function Run() { //console.log('running...');
					angular.forEach ($scope.Creatures, function (Creature)
					{
					 Creature.Move();
					 Creature.Eat();
				 	 Creature.Reproduce();					
					});

					$scope.Promise = $timeout(Run, 10);
				}
			//C.Run = function() {};
	
			$scope.HandleKeypress = function (e) 
			{ // console.log(e.which);
				switch(e.which)
				{ 
					case 82: $scope.CreatureType = 'red'; break;//r(ed)
					case 71: $scope.CreatureType = 'green'; break;//g(reen)
					case 66: $scope.CreatureType = 'blue'; break;//b(lue)
					case 88: Run(); break;// x
					case 90: $timeout.cancel($scope.Promise); break;
					default: console.log('pressed a boring key');
				} 
			 
			};	
			$scope.HandleClick = function (e) { AddCreature(e.x + window.scrollX, e.y + window.scrollY); }	
		}
	])
	.directive('mykeypress', [function ()
		{
			return 	{
					restrict: 'A',
					scope: {mykeypress: '&'},
					controller: function ($scope, $element) { 
						$element.bind('keydown', function (event) {
							$scope.$apply(function(){ 
								$scope.mykeypress({event: event})} );
							}); 
						} 
					}
		}
	])
;

