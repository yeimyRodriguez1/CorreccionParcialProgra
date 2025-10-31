defmodule ComplejoC do
  def f(n) when n <= 2, do: n + 1

  def f(n) when rem(n, 2) == 0 do
    f(n - 1) + g(div(n, 2), rem(n, 3))
  end

  def f(n) do
    g(n - 2, rem(n, 4)) - f(n - 1)
  end

  defp g(a, 0), do: f(a - 1)
  defp g(a, 1), do: 2 * f(a)
  defp g(a, _), do: f(a - 2) + 1
end


