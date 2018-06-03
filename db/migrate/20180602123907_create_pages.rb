class CreatePages < ActiveRecord::Migration[5.2]
  def change
    create_table :pages do |t|
      t.string :url
      t.string :uuid
      t.string :ipaddr
      t.binary :source
      t.text :domain_whois
      t.text :ipaddr_whois

      t.timestamps
    end
  end
end
