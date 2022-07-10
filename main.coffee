Number::to = (end, skip) ->
    val = @valueOf()
    arr = (num for num in [val..end])
    if skip and skip > 1 then arr = arr.filter( (v,i) => i % skip == 0)
    arr

Array::random = () ->
    len = @length
    rn = rangedRandom(len)
    @[rn]

rangedRandom = (limit) -> Number((Math.random() * limit) % (limit - 1)).toFixed(0)

$ = (sel) -> document.querySelector sel

svg = $ "svg"
gradientStartColor = $("#start-color")
gradientEndColor = $("#end-color")
skipValueElement = $("#skip-value")
lineColorElement = $("#line-color")
skipValue = () -> skipValueElement.value
lineColor = () -> lineColorElement.value

onchange = () =>
    svg.style.backgroundImage = "linear-gradient(#{gradientStartColor.value}, #{gradientEndColor.value})"


xlimit = svg.clientWidth
ylimit = svg.clientHeight
console.log "limits:", xlimit, ylimit

dasharray = [
    "1 1 2 2 3 3 5 5 8 8 13 13 21 21 13 13 8 8 5 5 3 3 2 2 1 1"
    "21 21 13 13 8 8 5 5 3 3 2 2 1 1"
    "1 1 2 2 3 3 5 5 8 8 13 13 21 21"
    "1 1 5 5 2 2 7 7 1 1"
    "1 1 5 5 1 1"
    "1 1 5 5 1 1 10 10 20 20 5 5 3 3"
    "5 5 10 10 2 2 4 4 1 1 3 3"
    "10"
    "20 10 5 3 2 1"
    "2"
]

curve = (pStart, color, ...coords) ->
    el = document.createElementNS("http://www.w3.org/2000/svg","path")
    el.setAttribute "d", "M #{pStart} #{coords.join ""}"
    el.setAttribute "fill", "none"
    el.setAttribute "stroke", color
    el.setAttribute "stroke-dasharray", dasharray.random()
    el

bezier = (p1, p2, p3) -> "S #{p1} #{p3}"
C = (p1,p2,p3) -> "C #{p1} #{p2} #{p3}"

pStr = (x, y) -> "#{x.toFixed(0)} #{y.toFixed(0)}"

color = (r=0, g=0, b=0, a = 1) -> "rgba(#{r}, #{g}, #{b}, #{a})"
rnColor = () -> color(rangedRandom(100), rangedRandom(100), rangedRandom(100))

P = (x, y) -> {x, y}

genCurves_left = () ->
    [xs, ys] = [0, xlimit/2]
    [xe, ye] = [xlimit/2, 0]
    ys.to(ylimit, skipValue()).map((p) =>
        curve(
            pStr(xs, p), lineColor(), bezier(
                pStr(xlimit/2, ylimit/2)
                pStr(xlimit/2, ylimit/2)
                pStr(xe, ye)
            )
        )
    )

genCurves_left_bottom = () ->
    [xs, ys] = [0, xlimit/2]
    [xe, ye] = [xlimit/2, 0]
    xs.to(xlimit/2, skipValue()).map((p) =>
        curve(
            pStr(p, ylimit), lineColor(), bezier(
                pStr(xlimit/2, ylimit/2)
                pStr(xlimit/2, ylimit/2)
                pStr(xe, ye)
            )
        )
    )

genCurves_right_bottom = () ->
    [xs, ys] = [xlimit/2, ylimit]
    [xe, ye] = [xlimit/2, 0]
    xs.to(xlimit, skipValue()).map((p) =>
        curve(pStr(p, ylimit), lineColor(), bezier(
            pStr(xlimit/2, ylimit/2)
            pStr(xlimit/2, ylimit/2)
            pStr(xe, ye)
        ))
    )

genCurves_right = () ->
    [xs, ys] = [xlimit, ylimit]
    [xe, ye] = [xlimit/2, 0]
    ys.to(ylimit/2, skipValue()).map((p) =>
        curve(
            pStr(xs, p), lineColor(), bezier(
                pStr(xlimit/2, ylimit/2)
                pStr(xlimit/2, ylimit/2)
                pStr(xe, ye)
            )
        )
    )

genCurves_right_top = () ->
    [xs, ys] = [xlimit/2, 0]
    xs.to(xlimit, skipValue()).map((p) =>
        curve(
            pStr(p, 0), lineColor(), bezier(
                pStr(xlimit/2 - 20, ylimit/2)
                pStr(xlimit/2 - 20, ylimit/2)
                pStr(xlimit, ylimit - p)
            )
        )
    )

genCurves_left_top = () ->
    [xs, ys] = [0, ylimit / 2]
    ys.to(0, skipValue()).map((p) =>
        curve(
            pStr(0, p), lineColor(), bezier(
                pStr(xlimit/2, ylimit/2)
                pStr(xlimit/2, ylimit/2)
                pStr(p, 0)
            )
        )
    )

curves = () -> [
    ...genCurves_left()
    ...genCurves_left_bottom()
    ...genCurves_right_bottom()
    ...genCurves_right()
    ...genCurves_right_top()
    ...genCurves_left_top()
]

render = () ->
    svg.innerHTML = ""
    curves().forEach((c) =>
        svg.append(c)
    )

onchange()
render()

gradientStartColor.addEventListener "input", onchange
gradientEndColor.addEventListener "input", onchange
skipValueElement.addEventListener "input", render
lineColorElement.addEventListener "input", render