class Creature
  constructor: (@position, @type = 'green', @prey, @energy = 9,  @reproductive_energy = 10, @min_energy = -10) ->
    @id = _.uuid()

  move: () =>
    if @energy > 0
      position = @_generate_position()
      @position = position
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
      position = @_generate_position(2)
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

  _generate_position: (radius = 1) =>
    position = {
      x: @position.x + Math.round((Math.random() * 2 * radius) - radius),
      y: @position.y + Math.round((Math.random() * 2 * radius) - radius),
    }


class Ecosystem
  constructor: (@creatures = {}, @width = 600, @height = 600) ->

  add_creature: (position, type, prey) =>
    creature = new Creature(position, type, prey)
    @creatures[creature.id] = creature

  population_size: ->
    _.keys(@creatures).length

  delete_creature: (creature) =>
    delete @creatures[creature.id]

  run: () =>
    before = new Date().getTime()
    _.each @creatures, (creature) ->
      creature.run_lifecycle(@)
    , @
    after = new Date().getTime()
    @loop_latency = after - before


window.Ecosystem = Ecosystem
window.Creature = Creature
