require 'spec_helper'
describe "My Site" do
  def app
   app_instance  = MySite.prepare_instance
  end
  context "before" do
    it "sets @title" do
      get "/"
      app.instance_variable_get("@title").should match("Thanks to the person that figured out how to get the Sinatra app instance")
    end
  end
end