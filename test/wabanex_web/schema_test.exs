defmodule WabanexWeb.SchemaTest do
  use WabanexWeb.ConnCase, async: true

  alias Wabanex.User
  alias Wabanex.Users.Create

  describe "users queries" do
    test "when a valid id is given, return a user", %{conn: conn} do
      params = %{email: "rafael@banana.com", name: "rafael", password: "123456"}

      {:ok, %User{id: user_id}} = Create.call(params)

      query = """
        {
          user(id: "#{user_id}") {
            name
            email
          }
        }
      """

      response =
        conn
        |> post("/api/graphql", %{query: query})
        |> json_response(:ok)

      expected_response = %{
        "data" => %{
          "user" => %{
            "email" => "rafael@banana.com",
            "name" => "rafael"
          }
        }
      }

      assert expected_response == response
    end
  end

  describe "users mutations" do
    test "when all params are valid, create a user", %{conn: conn} do
      mutation = """
       mutation {
         createUser(input: {
           name: "Joao", email: "joao@gmail.com", password: "1235456"
         }){
           id
           name
         }
       }
      """

      response =
        conn
        |> post("/api/graphql", %{query: mutation})
        |> json_response(:ok)

      expected_response =
        assert %{
                 "data" => %{
                   "createUser" => %{
                     "id" => _id,
                     "name" => "Joao"
                   }
                 }
               } = response
    end
  end
end
