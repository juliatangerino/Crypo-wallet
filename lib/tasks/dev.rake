namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Apagando BD...") {%x(rails db:drop)}
      show_spinner("Criando BD...") {%x(rails db:create)}
      show_spinner("Migrando BD...") {%x(rails db:migrate)}
      %x(rails dev:add_coins)
      %x(rails dev:add_mining_type)
    else
      "Você não está em ambiente de desenvolviemento"
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastrando moedas...") do

    coins = [
    
                { description: "Bitcoin", acronym: "BTC", url_image: "https://i.imgur.com/OYSaUEc.png" },
    
                { description: "Dash", acronym: "DASH", url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/131.png" },
    
                { description: "Ethereum", acronym: "ETH", url_image: "https://cryptologos.cc/logos/ethereum-eth-logo.png" },

                { description: "Iota", acronym: "IOT", url_image: "https://coingolive.com/assets/img/coin/iota.png" },

                { description: "Zcash", acronym: "ZEC", url_image: "https://s2.coinmarketcap.com/static/img/coins/200x200/1437.png" }
    
             ]
            
    coins.each do |coin|
        Coin.find_or_create_by!(coin)
    end
  end
end

  desc "Cadastrar os tipos de mineração"
  task add_mining_type: :environment do
    show_spinner("Cadastrando os tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"}
      ]
      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  def show_spinner(msg_start, msg_end = "Concluído")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
      yield
    spinner.auto_spin
    spinner.success(msg_end)
    end
end
