<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Http\Requests\UpdateProductRequest;
use App\Models\Product;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response;

class ProductController extends Controller
{
     public function index(Request $request){
        $perPage = $request->query("per_page", 10);
        $page = $request->query("page", 0);
        $offset = $page * $perPage;

        $products = Product::skip($offset)->take($perPage)->get();

        return response()->json($products);
     }

     public function store(Request $request){

        try{
            $validatedData = $request->validate([
                'name' => 'required|string|max:255',
                'description' => 'required|max:2000',
                'price' => 'required|numeric',
                'category_id' => 'required|exists:category,id'
            ],[
                "name.required" => 'El nombre del producto es obligatorio.',
                'name.string' => 'El nombre debe ser una cadena de texto.',
                'name.max' => 'El nombre no puede superar los 255 caracteres.',
                'description.required' => 'La descripción es obligatoria',
                'description.max' => 'La descripción no puede superar los 2000 caracteres.',
                'price.required' => 'El precio es obligatorio.',
                'price.numeric' => 'El precio debe ser un número.',
                'category_id.required' => 'La categoría es obligatoria.',
                'category_id.exists' => 'La categoría seleccionada no es válida.',
            ]);

            $product = Product::create($validatedData);

            return response()->json($product);
        }catch(ValidationException $e) {
            return response()->json(["errors" => $e->errors()], Response::HTTP_UNPROCESSABLE_ENTITY);
        }
     }

     public function update(UpdateProductRequest $request, Product $product){
        try{
            $validatedData = $request->validated();
            $product->update($validatedData);

            return response()->json(["message" => "Producto actualizado exitosamente", "product"=>$product]);
        }catch(Exception $e) {
            return response()->json(["error" => $e], Response::HTTP_INTERNAL_SERVER_ERROR);
        }
     }

     public function destroy(Product $product){
        $product->delete();
        return response()->json(["message"=>"Producto eliminado"]);
     }
}
