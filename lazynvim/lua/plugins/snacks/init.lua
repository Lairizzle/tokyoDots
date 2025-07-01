return {
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    dashboard = {
      preset = {
        -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
        ---@type fun(cmd:string, opts:table)|nil
        pick = nil,
        -- Used by the `keys` section to show keymaps.
        -- Set your custom keymaps here.
        -- When using a function, the `items` argument are the default keymaps.
        ---@type snacks.dashboard.Item[]
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
          },
          { icon = " ", key = "s", desc = "Restore Session", section = "session" },
          { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
        -- Used by the `header` section
        header = [[
                                                       .                                         .                                                    
                                ..                     ::                                       ^:                     ..                             
                                 :^:.                  :^^                                     ~^:                  .::.                              
                                  .^~^:                .:~^                                   ^~:.                :^^:.                               
                                   .::^:.              .::~.                                 .~::.              .^~::.                                
                                     :::^:.            .:.::                                .::.:.            .:^:::                                  
                                      ::::::.           ::.:.              ^7:              ::.::           .:^^::.                                   
                                       .:.:::.    :.    :^.~!.           ~YBPBY!.          .!^:^:    .:    .:::::.                                    
                   ....                 .::.:^:.  .^^.  .7J?P!        .?GBB#?B##GY^        7P7Y!.  .^^.  .:^:.::.                ..::.                
                    .:^^^::.        ..   .:!:7J~.  :::. .7Y!!J!      7B#BB&@7#@&#BB5:     !57!?!. .^::  .~J!^!:.  ...        .:^^^^.                  
                        .:^^^^:.     .^^:..~5YP5?^ .:.:: !Y:7~7^    ?&BGB@@@J5@@&BGBB^   ^Y^7:7! ::.:. ^J55Y5^..^^:.     .:^^^^:.                     
                          ..::^^^:.    :^^:.!5PPP57 :^.~!~57.J^!   ^#GGGB&@@J5@@#GGG#P   ~^?^:P~!^.^:.75PPPY~.:^^:    .::^^::..                       
                             .::::::^:  .:::::!YPPP! !J^YYYJ !J    G&BGGB@@@5Y@&&BGG##.   ^? ~YJJ^Y~ 7PGGJ!:::::   :^.:::::.                          
                               ..::!7JJ7^..::.!~!YGP~.55YGG!.~J   :#BGGGB#BB#Y7PGGGGB#^:  !7::5GJ5Y.!PG5!~~.::..^7JJ7!::.                             
                                  .~J5PPPY^ ~?7YY7?GBJ~YGBJ.^~7 :?:YGYBGGBPJJ?!!GBGG5P.J! ^7::~GGY~YBGJ7YY7?^ ^5PPP5J^.                               
                             .....   ~J5PP57:^Y5GG5YGGY7J!:~:!: !^ !J5BGGYJ7:..JYPGGY! .?. !^~:^?!JGP55GG5Y^:?5PP5J~   ....                           
                   ............::::::::~!7JYP5J5J?!!~~~:^^~^:!. ^^ ^YP5Y?!~....^??JYG? .~. ^~:~~^:^~~~!7JY?5PYJ7~^::::::::............                
                  ..:^^^~~~~~^^::^~^::..:7Y5G57~~~!!^:~^^^^:~~:^:~ !JYJ~:.........:~?J.^^::^~:^^^:~^^!!!~^!YPPJ!:..::^~^::^^~~~~~^^::..               
                         ...::::~7J5YJ?!!?PP!~~!J55G57:~~:::~!?!::^!^:..............:7!.:~?7~:^:~~:!YGP5Y7~~~5P?!!?J55J7~::::...                      
                               ..:~7???777?^!!~5PPGBB5!~?J7:~:^Y!.:...:::.::|::.::...::~5~:!:!J?~!PBBBP5P?~7:7777???!~:..                            
                                       ^77.7!^~5P5PGY?^^~YG~:^75P:^..:^~:^57J7Y?.^^:..^:YP?^~:G57~!7YGP55P?^!7.77:                                    
                               .:^^^^^:~Y~~!^^^~?JJJJY!:.JP~.:^5?~7^::...?Y!GY75^ .::~7~!P~:.:5Y:.^JJYJJ?!^^^~~~Y~:^^~^^:.                            
                              .::........:^^^^:^^~~~~!7?..~~~^~!!~7J:^^::.7!?~?:.:::^5?~!!~^^~~: !!7!~~~^^::^^^:.......:::.                           
                                     :^^:::^^~?JYPGY~ ^:.~~  .  !!:~?~^^~::?^!7 ^:^^?!.~7. .. ^~:.^.:JGG5Y?!^^::::^:                                  
                                         .^^^!!!!!77^:^ :!~~^~^^:?^^&Y.^.~7Y~!7~^J?:#!:7~:^~^~~7^ :^:!77!!!!^^^.                                      
                                       .^^::^^!7?Y7::::..~7JYYJ?7~:J&!!7YGPY^::!^~!Y@5:~7?JYYY7~: ^:^.!YJ7!~^^:^^:                                    
                                           ^^~77?J!░░░    ░░ ░░░░░░░  ░░░░░░  ░░    ░░ ░░ ░░░    ░░░!J?77~^^:                                         
                                         .:::^~!7!:▒▒▒▒   ▒▒ ▒▒      ▒▒    ▒▒ ▒▒    ▒▒ ▒▒ ▒▒▒▒  ▒▒▒▒:!7!~^:::.                                        
                                         ..:^!777!^▒▒ ▒▒  ▒▒ ▒▒▒▒▒   ▒▒    ▒▒ ▒▒    ▒▒ ▒▒ ▒▒ ▒▒▒▒ ▒▒^~777!^^..                                        
                                          :^:  ....▓▓  ▓▓ ▓▓ ▓▓      ▓▓    ▓▓  ▓▓  ▓▓  ▓▓ ▓▓  ▓▓  ▓▓....  .::                                         
                                          ^^. .....██   ████ ███████  ██████    ████   ██ ██      ██..... :^.                                         
                                         ]],
      },
    },
  },
}
