require('vis')

--Select multiple words (to change them just press "c")
vis:map(vis.modes.NORMAL, 'gx', function()
    vis:feedkeys(':x//<Left>')
end)
