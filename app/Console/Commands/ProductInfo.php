<?php

namespace App\Console\Commands;

use App\Models\Product;
use Illuminate\Console\Command;

class ProductInfo extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:product-info {id : Id del producto a consultar}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Consuta la información de un producto en la base de datos';

    /**
     * Execute the console command.
     */
    public function handle()
    {
         $id = $this->argument("id");

         $product = Product::find($id);

         if(!is_numeric($id) || $id <= 0){
            $this->error("Error: El ID debe ser un número positivo.");
            return Command::FAILURE;
         }

         if(!$product){
            $this->error("El producto no existe");
            return Command::FAILURE;
         }

         $this->info("Producto encontrado");
         $this->info("Nombre: {$product->name}");
         $this->info("Descripción: {$product->description}");
         $this->info("Precio: {$product->price}");
    }
}
