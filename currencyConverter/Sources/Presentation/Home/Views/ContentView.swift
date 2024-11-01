import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: Converter = Converter()
    @State var selecting: Int? = nil
    var body: some View {
        ZStack {
            Color.black
                .opacity(selecting == nil ? 1 : 0.9)
                .ignoresSafeArea()
                .animation(.easeInOut, value: selecting)
            VStack {
                HStack {
                    Button(
                        action: { viewModel.swapCurrency() },
                        label: {
                            Text("⇅")
                                .foregroundStyle(
                                    Color(red: 234 / 255, green: 158 / 255, blue: 58 / 255)
                                )
                                .font(.system(size: 30))
                        }
                    )
                    .padding()
                    VStack {
                        inputView(fieldNum: 0, selecting: $selecting, viewModel: viewModel)
                        Divider()
                            .frame(height: 1)
                            .overlay(.gray)
                        inputView(fieldNum: 1, selecting: $selecting, viewModel: viewModel)
                    }
                }
                KeyboardView
                    .padding()
            }
            .sheet(
                item: $selecting
            ) { selecting in
                CurrenciesView(viewModel: viewModel, fieldNum: $selecting)
            }
        }
        .enableInjection()
    }

    var KeyboardView: some View {
        Grid {
            GridRow {
                CButton("⇦", onTap: { viewModel.remove() })
                CButton("AC", onTap: { viewModel.clear() })
                CButton("%", onTap: { viewModel.insert("%") })
                CButton(
                    "÷", .init(red: 234 / 255, green: 158 / 255, blue: 58 / 255),
                    onTap: { viewModel.insert("/") }
                )
            }
            GridRow {
                CButton("7", onTap: { viewModel.insert("7") })
                CButton("8", onTap: { viewModel.insert("8") })
                CButton("9", onTap: { viewModel.insert("9") })
                CButton(
                    "×", .init(red: 234 / 255, green: 158 / 255, blue: 58 / 255),
                    onTap: { viewModel.insert("*") }
                )
            }
            GridRow {
                CButton("4", onTap: { viewModel.insert("4") })
                CButton("5", onTap: { viewModel.insert("5") })
                CButton("6", onTap: { viewModel.insert("6") })
                CButton(
                    "-", .init(red: 234 / 255, green: 158 / 255, blue: 58 / 255),
                    onTap: { viewModel.insert("-") }
                )
            }
            GridRow {
                CButton("1", onTap: { viewModel.insert("1") })
                CButton("2", onTap: { viewModel.insert("2") })
                CButton("3", onTap: { viewModel.insert("3") })
                CButton(
                    "+", .init(red: 234 / 255, green: 158 / 255, blue: 58 / 255),
                    onTap: { viewModel.insert("+") }
                )
            }
            GridRow {
                CButton(" ")
                CButton("0", onTap: { viewModel.insert("0") })
                CButton(".", onTap: { viewModel.insert(".") })
                CButton(
                    "=", .init(red: 234 / 255, green: 158 / 255, blue: 58 / 255),
                    onTap: {
                        viewModel.calInput()
                    })
            }
        }
    }

    @ObserveInjection var inject
}
