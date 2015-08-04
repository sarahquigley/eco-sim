class Creature
  constructor: (@position, @type = 'green', @prey, @energy = 9,  @reproductive_energy = 10, @min_energy = -10) ->
    @id = _.uuid()

  move: () =>
    if @energy > 0
      @position.x +=  Math.round(Math.random() * (2) - 1)
      @position.y +=  Math.round(Math.random() * (2) - 1)
      @energy -= 0.1
    else
      @energy -= 0.01

  eat: (ecosystem) =>
    if _.isString(@prey)
      _.each _.where(ecosystem.creatures, {type: @prey}), (prey)  ->
        if Math.abs(prey.position.x - @position.x) < 2 && Math.abs(prey.position.y - @position.y) < 2 && prey.id != @id
          prey.die(ecosystem)
          @energy += 9
      , @
    else
      @energy += 0.15

  reproduce: (ecosystem) =>
    if @energy > @reproductive_energy
      position = {
        x: Math.round(@position.x + Math.random() * 4 - 2).
        y: Math.round(@position.y + Math.random() * 4 - 2),
      }
      if !_.any(ecosystem.creatures, {position: position})
        creature = ecosystem.add_creature(position, @type)
        @energy -= @reproductive_energy
        creature

  die: (ecosystem) =>
    ecosystem.delete_creature(@)

  run_lifecycle: (ecosystem) =>
    @move()
    if @energy < @min_energy
      @die(ecosystem)
    @eat(ecosystem)
    @reproduce(ecosystem)


class Ecosystem
  constructor: (@creatures = {}) ->

  add_creature: (position, type, prey) =>
    creature = new Creature(position, type, prey)
    @creatures[creature.id] = creature

  delete_creature: (creature) =>
    delete @creatures[creature.id]

  run: () =>
    _.each @creatures, (creature) ->
      creature.run_lifecycle(@)
    , @


window.Ecosystem = Ecosystem
window.Creature = Creature
